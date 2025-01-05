const app = require('./app');
const turf = require('@turf/turf');
const express = require('express');



exports.calcSquareJson = function (newLatLon, side, direction, cellSide) {
    side = side / 100.0;
  
    let latlon1 = [newLatLon[0] + side, newLatLon[1] + side / 2];
    let latlon2 = [newLatLon[0] + side, newLatLon[1] - side / 2];
    let latlon3 = [newLatLon[0] - side, newLatLon[1] - side / 2];
    let latlon4 = [newLatLon[0] - side, newLatLon[1] + side / 2];
  
    let poly = turf.polygon([
      [
        [latlon1[1], latlon1[0]],
        [latlon2[1], latlon2[0]],
        [latlon3[1], latlon3[0]],
        [latlon4[1], latlon4[0]],
        [latlon1[1], latlon1[0]],
      ],
    ]);
    let options = { pivot: [newLatLon[1], newLatLon[0]] };
    let rotatedPoly = turf.transformRotate(poly, direction, options);
    let area = turf.area(poly) / 1000000;
  
    const { coordinates } = rotatedPoly.geometry;
  
  
    var features = turf.featureCollection([
      turf.point(coordinates[0][0], { name: 'A' }),
      turf.point(coordinates[0][1], { name: 'B' }),
      turf.point(coordinates[0][2], { name: 'C' }),
      turf.point(coordinates[0][3], { name: 'D' }),
    ]);
  
    var bigRec = turf.envelope(features);
  
    let squareGrid = turf.squareGrid(bigRec.bbox, cellSide);
  
    let filteredGrid = {
      type: 'FeatureCollection',
      features: [],
    };
    filteredGrid.features = squareGrid.features.filter((obj) => {
      let poly2 = turf.polygon(obj.geometry.coordinates);
      let centroid = turf.centroid(poly2);
  
      return turf.booleanPointInPolygon(centroid, rotatedPoly);
    });
  
    return {
      geojson: {
        type: 'FeatureCollection',
        features: [
          {
            type: 'Feature',
            id: Math.random(),
            center: [newLatLon[0].toPrecision(8), newLatLon[1].toPrecision(8)],
  
            properties: {
              type: 'land',
              area: area.toFixed(2) + ' sq km',
              shape: 'rectangle',
              description: 'this area is very dangerous.',
              crashPoint:
                newLatLon[0].toPrecision(8) + ' , ' + newLatLon[1].toPrecision(8),
            },
            geometry: {
              type: 'Polygon',
              coordinates: [
                [
                  [coordinates[0][0][0], coordinates[0][0][1]],
                  [coordinates[0][1][0], coordinates[0][1][1]],
                  [coordinates[0][2][0], coordinates[0][2][1]],
                  [coordinates[0][3][0], coordinates[0][3][1]],
                  [coordinates[0][4][0], coordinates[0][4][1]],
                ],
              ],
            },
          },
        ],
      },
      filteredGrid,
    };
  };

  exports.calcCircleJson = function(newLatLon, side, direction, cellSide) {
    side=side*100;
    const numPoints = 360;
    const circle = turf.circle([newLatLon[1], newLatLon[0]], side, {
        steps: numPoints,
        units: 'meters'
    });

    const area = turf.area(circle);
    const { coordinates } = circle.geometry;

    let squareGrid = turf.squareGrid(turf.envelope(circle).bbox, cellSide);
    
    let filteredGrid = {
        type: 'FeatureCollection',
        features: [],
    };
    filteredGrid.features = squareGrid.features.filter((obj) => {
        let poly2 = turf.polygon(obj.geometry.coordinates);
        let centroid = turf.centroid(poly2);
        return turf.booleanPointInPolygon(centroid, circle);
    });

    return {
        geojson: {
            type: 'FeatureCollection',
            features: [
                {
                    type: 'Feature',
                    id: Math.random(),
                    center: [newLatLon[0].toPrecision(8), newLatLon[1].toPrecision(8)],
                    properties: {
                        type: 'land',
                        area: area.toFixed(2) + ' sq km',
                        shape: 'circle',
                        description: 'this area is very dangerous.',
                        crashPoint:
                            newLatLon[0].toPrecision(8) + ' , ' + newLatLon[1].toPrecision(8),
                    },
                    geometry: {
                        type: 'Polygon',
                        coordinates: coordinates,
                    },
                },
            ],
        },
        filteredGrid,
    };
};
