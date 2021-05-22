#!/bin/bash

set -e
HOST="buechele@buechele.cc"
DIR="~/feedshare"

cd "$(dirname "$0")/.."
yarn build
rsync -avz --delete public dist prisma package.json yarn.lock $HOST:$DIR
ssh $HOST 'cd ~/feedshare; yarn install --production; yarn generate:prisma; supervisorctl restart feedshare'
