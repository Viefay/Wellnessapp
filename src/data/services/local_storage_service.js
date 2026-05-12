import { dummySessions } from '../../core/utils/dummy_data.js';

// In-memory session store. Replace with Firebase/Supabase/SQLite when ready.
const _sessions = [...dummySessions];

export function getSessions() {
  return [..._sessions];
}

export function addSession(session) {
  _sessions.unshift(session);
}

export function getSessionById(id) {
  return _sessions.find(s => s.id === id) || null;
}

export function clearSessions() {
  _sessions.length = 0;
}
