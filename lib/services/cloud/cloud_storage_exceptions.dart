class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}

class CouldNotCreateGoalException extends CloudStorageException {}

class CouldNotGetAllGoalsException extends CloudStorageException {}

class CouldNotUpdateGoalException extends CloudStorageException {}

class CouldNotDeleteGoalException extends CloudStorageException {}

class CouldNotCreateQuestionException extends CloudStorageException {}

class CouldNotGetAllQuestionsException extends CloudStorageException {}

class CouldNotUpdateQuestionException extends CloudStorageException {}

class CouldNotDeleteQuestionException extends CloudStorageException {}
