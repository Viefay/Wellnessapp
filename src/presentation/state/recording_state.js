export const recordingState = {
  selectedFoot: 'right', // 'right' | 'left'
  isRecording: false,
  timeRemaining: 30,
  totalTime: 30,
  timerInterval: null,
};

export function resetRecording() {
  if (recordingState.timerInterval) clearInterval(recordingState.timerInterval);
  recordingState.isRecording = false;
  recordingState.timeRemaining = 30;
  recordingState.timerInterval = null;
}
