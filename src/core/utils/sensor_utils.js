/**
 * Calculates Free Acceleration from raw accelerometer data.
 * FreeAcc = AccTotal - Gravity, where AccTotal = sqrt(x²+y²+z²)
 */
export function calculateFreeAcc(accX, accY, accZ) {
  const accTotal = Math.sqrt(accX * accX + accY * accY + accZ * accZ);
  return accTotal - 9.81;
}

/**
 * Validates a list of SensorData objects.
 * Returns true if data is non-empty, has valid timestamps, no NaN values,
 * sufficient sample count, and a valid foot side.
 */
export function isValidSensorData(data) {
  if (!data || data.length === 0) return false;
  if (data.length < 10) return false;

  const validFootSides = ['right', 'left'];

  for (const sample of data) {
    if (!validFootSides.includes(sample.footSide)) return false;
    if (typeof sample.timestamp !== 'number' || sample.timestamp <= 0) return false;

    const numFields = [sample.accX, sample.accY, sample.accZ, sample.gyrX, sample.gyrY, sample.gyrZ];
    for (const val of numFields) {
      if (typeof val !== 'number' || isNaN(val)) return false;
    }
  }

  return true;
}
