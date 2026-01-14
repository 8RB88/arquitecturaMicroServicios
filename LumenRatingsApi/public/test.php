<?php
echo json_encode([
    'status' => 'OK',
    'message' => 'Servidor respondiendo correctamente',
    'time' => date('Y-m-d H:i:s'),
    'path' => $_SERVER['REQUEST_URI']
]);
