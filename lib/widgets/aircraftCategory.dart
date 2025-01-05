String getCategoryName(int category) {
  switch (category) {
    case 0:
      return "No information at all";
    case 1:
      return "No ADS-B Emitter Category Information";
    case 2:
      return "Light (< 15500 lbs)";
    case 3:
      return "Small (15500 to 75000 lbs)";
    case 4:
      return "Large (75000 to 300000 lbs)";
    case 5:
      return "High Vortex Large (B-757)";
    case 6:
      return "Heavy (> 300000 lbs)";
    case 7:
      return "High Performance (> 5g acceleration and 400 kts)";
    case 8:
      return "Rotorcraft";
    case 9:
      return "Glider / sailplane";
    case 10:
      return "Lighter-than-air";
    case 11:
      return "Parachutist / Skydiver";
    case 12:
      return "Ultralight / hang-glider / paraglider";
    case 13:
      return "Reserved";
    case 14:
      return "Unmanned Aerial Vehicle";
    case 15:
      return "Space / Trans-atmospheric vehicle";
    case 16:
      return "Surface Vehicle – Emergency Vehicle";
    case 17:
      return "Surface Vehicle – Service Vehicle";
    case 18:
      return "Point Obstacle (includes tethered balloons)";
    case 19:
      return "Cluster Obstacle";
    case 20:
      return "Line Obstacle";
    default:
      return "Unknown Category";
  }
}