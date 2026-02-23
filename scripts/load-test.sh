#!/usr/bin/env bash
set -euo pipefail

LMS_URL=${1:?"LMS URL required"}

cat <<K6 > /tmp/openedx-load.js
import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 50 },
    { duration: '3m', target: 200 },
    { duration: '2m', target: 50 },
  ],
};

export default function () {
  http.get(`${__ENV.LMS_URL}/`);
  sleep(1);
}
K6

k6 run -e LMS_URL="${LMS_URL}" /tmp/openedx-load.js
