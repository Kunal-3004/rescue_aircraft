const Airplane = require('./model/Airplane');

class AirplaneService {
  static async getAllAirplanes() {
    return await Airplane.find({});
  }

  static async createAirplane(data) {
    const airplane = new Airplane(data);
    return await airplane.save();
  }
}

module.exports = AirplaneService;
