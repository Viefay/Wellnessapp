import { dummyResult } from '../../core/utils/dummy_data.js';

const API_BASE = '/api';

/**
 * Placeholder API service.
 * POST /api/analyze — sends raw sensor data, returns GaitResult.
 * Currently returns dummy data while backend is not connected.
 */
export async function analyzeGaitSession({ rightFootData, leftFootData, userId = 'user_001', sessionId = 'session_001' }) {
  // Uncomment to call real backend:
  // const response = await fetch(`${API_BASE}/analyze`, {
  //   method: 'POST',
  //   headers: { 'Content-Type': 'application/json' },
  //   body: JSON.stringify({
  //     user_id: userId,
  //     session_id: sessionId,
  //     right_foot_data: rightFootData.map(s => s.toJson ? s.toJson() : s),
  //     left_foot_data: leftFootData.map(s => s.toJson ? s.toJson() : s),
  //   }),
  // });
  // return response.json();

  await new Promise(r => setTimeout(r, 500)); // simulate latency
  return { ...dummyResult };
}
