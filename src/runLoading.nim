import os, std/threadpool
import vars

const loadingSymbols: array[7, string] = [
  "⣾",
  "⣷",
  "⣯",
  "⣟",
  "⡿",
  "⣻",
  "⣽",
]

var done = false

proc showLoadingAnimation() {.thread.} =
  while not done:
    for symbol in loadingSymbols:
      if done:
        break
      stdout.write(symbol)
      sleep(100)
      stdout.flushFile()
      stdout.write("\b")

proc runLoading*(task: proc()) =
  done = false
  spawn showLoadingAnimation()

  try:
    task()
  finally:
    done = true
    sync()
    stdout.write colorReset

# stdout.write "Starting work "
# runLoading(myLongRunningTask)
# echo "\nWork complete!"
