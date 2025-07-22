#!/bin/bash
mkdir -p /home/akira/.config/systemd
ln -s ~/code/common-stuff/.config/systemd/user/rclone-onedrive-personal.service /home/akira/.config/systemd/user/rclone-onedrive-personal.service
systemctl --user daemon-reload
systemctl --user enable rclone-onedrive-personal
systemctl --user start rclone-onedrive-personal
