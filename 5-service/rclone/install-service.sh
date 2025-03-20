#!/bin/bash
ln -sf $(realpath rclone-onedrive-uit.service)  ~/.config/systemd/user/rclone-onedrive-uit.service
ln -sf $(realpath rclone-onedrive-personal.service)  ~/.config/systemd/user/rclone-onedrive-personal.service
