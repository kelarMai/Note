.log.log:{[lvl;msg]
    -1 (string lvl), msg;
    -1 msg;
    msg
 };

.log.information:.log.log[`info]

show "Hello Wrold"