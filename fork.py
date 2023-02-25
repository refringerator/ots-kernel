import os, time
import sys
import random


def log(text):
    print(f"[{os.getpid()}] {text}")


def impossible_job(a):
    time.sleep(a % 10)
    return random.randint(0, 1)


def to_int(int16):
    return int(int16 / 256)


if __name__ == "__main__":
    log("Здрасьте! Я начальник. Слышал, что в линукс курсе нужно обновить методички.")
    log("Кто там главный по курсу, давайте его позовем!")

    pid = os.fork()

    if pid == 0:
        teachers_count = 40
        teachers_pids = []
        log(
            f"Я руководитель курса. Пусть все {teachers_count} преподавателей сами разберуться"
        )
        for i in range(1, teachers_count):
            a = 2**i
            log(f"Эй, нужно обновить методичку #{a}")
            pid = os.fork()

            if pid == 0:
                log(f"Эх, мне досталась самая сложная методичка #{a}")
                result = impossible_job(a)
                log(f"Готово, {'почти ' if result==1 else ''}получилось!")
                sys.exit(result)

            teachers_pids.append(pid)
            log(f"Так-с, {pid}`у выдали работенку..")

        log("Вздремнем, пока они там работают. Zzz..zz..zz")

        res = 0
        for tpid in teachers_pids:
            _, status = os.waitpid(tpid, 0)
            res += 0 if status == os.EX_OK else 1

        sys.exit(res)

    log(f"PID руководителя {pid}, подожду, пока он там со всем разберется.")
    pid, status = os.waitpid(pid, 0)
    log(
        f"Руководитель курса доложил, что не получилось обновить {to_int(status)} методичек"
    )
