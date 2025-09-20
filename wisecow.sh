#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

# Clean up and create named pipe
rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    # Process the request
    get_api
    # Use correct paths - both fortune and cowsay are in /usr/games
    mod=`/usr/games/fortune`
    cat <<EOF > $RSPFILE
HTTP/1.1 200 OK
Content-Type: text/html

<pre>`/usr/games/cowsay "$mod"`</pre>
EOF
}

prerequisites() {
    # Check if commands exist - both are in /usr/games
    if [ -f /usr/games/fortune ] && [ -f /usr/games/cowsay ]; then
        echo "Prerequisites found."
        return 0
    else
        echo "Install prerequisites."
        echo "fortune path: $(find /usr -name fortune 2>/dev/null || echo 'not found')"
        echo "cowsay path: $(find /usr -name cowsay 2>/dev/null || echo 'not found')"
        return 1
    fi
}

main() {
    echo "Starting wisecow application..."
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."
    
    # Use netcat-openbsd syntax
    while true; do
        cat $RSPFILE | nc -l -p $SRVPORT | handleRequest
        sleep 0.01
    done
}

main