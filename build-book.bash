#!/bin/bash
rm -rf _book docs
gitbook build ./zh-tw ./docs
gitbook pdf ./zh-tw ./botnana-book_zh-tw.pdf