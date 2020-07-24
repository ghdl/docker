FROM archlinux

RUN pacman -Syu --noconfirm --noprogressbar --needed grep base-devel
