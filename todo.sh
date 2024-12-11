#!/bin/bash

TODO_FILE="./todo_list.txt"
DONE_FILE="./todo_done.txt"

if [[ -z "$TERM" || "$TERM" == "dumb" ]]; then
  GREEN=""
  RED=""
  RESET=""
else
  GREEN="\033[32m"
  RED="\033[31m"
  RESET="\033[0m"
fi

function clear_screen() {
  clear
}

# statistic
function show_stats() {
  local total_tasks=$(wc -l <"$TODO_FILE" 2>/dev/null || echo 0)
  local done_tasks=$(wc -l <"$DONE_FILE" 2>/dev/null || echo 0)
  local pending_tasks=$((total_tasks - done_tasks))

  echo -e "${GREEN} ✔ $done_tasks Done${RESET} ${RED}✔ $pending_tasks In Progress${RESET}"
}

# show todo
function show_todo() {
  if [[ -s $TODO_FILE ]]; then
    echo "To-Do List:"
    cat -n "$TODO_FILE"
  else
    echo "The List is empty"
  fi
}

function add_todo() {
  echo "$1" >>"$TODO_FILE"
  echo "Task was added: $1"
}

function mark_done() {
  local task=$(sed -n "${1}p" "$TODO_FILE")
  if [[ -n $task ]]; then
    echo "$task" >>"$DONE_FILE"
    sed -i "${1}d" "$TODO_FILE"
    echo "Task №$1 done"
  else
    echo "Task №$1 not found"
  fi
}

function remove_todo() {
  sed -i "${1}d" "$TODO_FILE"
  echo "Task was deleted №$1."
}

function clear_todo() {
  >"$TODO_FILE"
  echo "List has been updated"
}

# menu
function menu() {
  clear_screen
  show_todo
  show_stats
  echo "-------------------------------------------------------"
  echo "[1] show [2] add [3] mark [4] delete [5] clean [6] quit"
  echo "-------------------------------------------------------"
  echo -n ">>> "
  read choice

  case $choice in
  1)
    clear_screen
    show_todo
    ;;
  2)
    echo -n "New task: "
    read task
    add_todo "$task"
    ;;
  3)
    show_todo
    echo -n "Task done: "
    read task_num
    mark_done "$task_num"
    ;;
  4)
    show_todo
    echo -n "Task to delete: "
    read task_num
    remove_todo "$task_num"
    ;;
  5)
    clear_todo
    ;;
  6)
    echo "Bye bye"
    exit 0
    ;;
  *)
    echo "Try again"
    ;;
  esac
}

# loop
while true; do
  menu
  echo -n "Hit enter to continue"
  read _
done
