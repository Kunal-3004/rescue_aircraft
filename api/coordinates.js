const app = require('./app');

function calcDistance(altitude, velocity) {
  velocity = velocity / 3600.0;

  const g = 9.8 / 1000.0;
  const time = Math.sqrt((2 * altitude) / g);

  return velocity * time;
}

function calculateExpectedCoordinates(lat, lng, heading, distance) {
  const R = 6371;
  const bearing = heading * (Math.PI / 180);
  const latRad = lat * (Math.PI / 180);
  const lonRad = lng * (Math.PI / 180);

  const newLat = Math.asin(
    Math.min(
      1,
      Math.max(
        -1,
        Math.sin(latRad) * Math.cos(distance / R) +
          Math.cos(latRad) * Math.sin(distance / R) * Math.cos(bearing)
      )
    )
  );

  const newLon =
    lonRad +
    Math.atan2(
      Math.sin(bearing) * Math.sin(distance / R) * Math.cos(latRad),
      Math.cos(distance / R) - Math.sin(latRad) * Math.sin(newLat)
    );

  const finalLat = newLat * (180 / Math.PI);
  const finalLon = newLon * (180 / Math.PI);

  return { latitude: finalLat, longitude: finalLon };
}

app.post('/calculate-coordinates', (req, res) => {
  const { latitude, longitude, heading, altitude, velocity } = req.body;

  if (latitude == null || longitude == null || heading == null || altitude == null || velocity == null) {
    return res.status(400).json({ error: "Missing required parameters" });
  }

  const distance = calcDistance(altitude, velocity);
  const expectedCoordinates = calculateExpectedCoordinates(latitude, longitude, heading, distance);

  return res.json({ expectedCoordinates });
});
