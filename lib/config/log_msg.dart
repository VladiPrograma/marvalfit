// Blue text
void logInfo(Object msg) {
  print('\x1B[34m${msg.toString()}\x1B[0m');
}

// Green text
void logSuccess(Object msg) {
  print('\x1B[32m${msg.toString()}\x1B[0m');
}

// Yellow text
void logWarning(Object msg) {
  print('\x1B[33m${msg.toString()}\x1B[0m');
}

// Red text
void logError(Object msg) {
  print('\x1B[31m${msg.toString()}\x1B[0m');
}