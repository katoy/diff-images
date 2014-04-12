#!/bin/bash


rm -fr diff
rm -fr thumbnail

ruby ../../tools/difftools/make-diffs.rb capture capture-prev diff

ruby ../../tools/difftools/make-thumbnails.rb capture thumbnail/capture
ruby ../../tools/difftools/make-thumbnails.rb capture-prev thumbnail/capture-prev
ruby ../../tools/difftools/make-thumbnails.rb diff thumbnail/diff
