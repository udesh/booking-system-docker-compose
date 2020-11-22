const cors = require('cors');
const express = require('express');
const mysql = require('mysql');
const moment = require('moment');
const Promise = require('bluebird');
require('moment-timezone');

const app = express();

const pool = mysql.createPool({
  host: process.env.MYSQL_HOST_IP,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE,
});

app.use(cors());

app.listen(process.env.REACT_APP_SERVER_PORT, () => {
  console.log(`App server now listening on port ${process.env.REACT_APP_SERVER_PORT}`);
});

function getDistanceFromLatLonInKm(latL1, lonL1, latL2, lonL2) {
  let Radius = 6371;
  let dLat = degreeToRadius(latL2 - latL1);
  let dLon = degreeToRadius(lonL2 - lonL1);
  let length =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(degreeToRadius(latL1)) * Math.cos(degreeToRadius(latL2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2)
    ;
  let circum = 2 * Math.atan2(Math.sqrt(length), Math.sqrt(1 - length));
  let distance = Radius * circum;
  return distance;
}

function degreeToRadius(deg) {
  return deg * (Math.PI / 180)
}

app.get('/vendors', (req, res) => {
  const { serviceType } = req.query;
  let defaultServiceType = serviceType != null ? serviceType : "LS";
  pool.query(`select * from vendors where service_type = '${defaultServiceType}'`, (err, results) => {
    if (err) {
      return res.send(err);
    } else {
      return res.send(results);
    }
  });
});

function calculateServiceMinutes(serviceType, areaType) { // LS, LM , S, M
  if (serviceType == "LS" && areaType == "S") {
    return 60;
  } else if (serviceType == "LS" && areaType == "M") {
    return 120;
  } else if (serviceType == "LM" && areaType == "S") {
    return 90;
  } else if (serviceType == "LM" && areaType == "M") {
    return 180;
  }
}

function getTimeBetweenLocations(bookedLocation, newLocation) {
  let query = '';
  if (bookedLocation == newLocation) {
    query = `select * from locations where id in (${bookedLocation})`;
  } else {
    query = `select * from locations where id in (${bookedLocation},${newLocation})`;
  }
  return new Promise(function (resolve, reject) {
    pool.query(query, (err, results, fields) => {
      if (err) {
        reject(err);
        return;
      } else {
        resolve(results);
      }
    });
  });
}

function getlatestBookings(vendorId, date) {
  let startTime = date + " 07:59:00";
  let endTime = date + " 17:01:00"
  let query = `select * from bookings where vendor_id = ${vendorId} AND start_time BETWEEN '${startTime}' AND '${endTime}' ORDER BY start_time DESC limit 1`;
  return new Promise(function (resolve, reject) {
    pool.query(query, (err, results, fields) => {
      if (err) {
        reject(err);
        return;
      } else {
        resolve(results);
      }
    });
  });
}

function saveBookings(vendorId, startTime, endTime, locationId) {
  let query = `INSERT INTO bookings (id, vendor_id, start_time, end_time, location_id, reference) 
                 VALUES ( NULL, '${vendorId}', '${startTime}', '${endTime}', '${locationId}', NULL)`;
  return new Promise(function (resolve, reject) {
    pool.query(query, (err, results, fields) => {
      if (err) {
        reject(err);
        return;
      } else {
        resolve(results);
      }
    });
  });
}

app.get('/bookings', (req, res) => {
  const { vendorId } = req.query;
  const { locationId } = req.query;
  const { date } = req.query;
  calculateTime(locationId, date, vendorId).then(time => {
    return res.send(time);
  });
});

app.post('/register', (req, res) => {
  const { vendorId } = req.query;
  const { locationId } = req.query;
  const { date } = req.query;
  const { timeSlot } = req.query;
  const { serviceType } = req.query;
  const { areaType } = req.query;
  if (vendorId == null || locationId == null || date == null || timeSlot == null || serviceType == null || areaType == null) {
    res.status('404').send("Error");
  }
  let startTime = moment(date + " " + timeSlot).tz("Asia/Colombo").format('YYYY-MM-DD HH:mm');
  let workTime = calculateServiceMinutes(serviceType, areaType);
  let endTime = moment(startTime).add(workTime, 'minutes').tz("Asia/Colombo").format('YYYY-MM-DD HH:mm');
  let booking = registerBooking(vendorId, startTime, endTime, locationId);
  res.status('200').send(booking);
});

async function registerBooking(vendorId, startTime, endTime, locationId) {
  try {
    const registerBooking = await saveBookings(vendorId, startTime, endTime, locationId);
  } catch (error) {

  }
  return registerBooking;
}

async function calculateTime(locationId, date, vendorId) {
  let serviceEnd = null;
  let bookedLocation = null;
  let timeReturn = 0;
  let accumilatedTime = null;
  let dateMonthAsWord = moment(date).tz("Asia/Colombo").format('YYYY-MM-DD');
  const bookings = await getlatestBookings(vendorId, dateMonthAsWord);
  if (bookings.length > 0) {
    serviceEnd = moment(bookings[0].end_time).tz("Asia/Colombo").format('HH:mm');
    let bookedLocation = bookings[0].location_id;
    const results = await getTimeBetweenLocations(bookedLocation, locationId);
    if (results.length > 1) {
      let distance = getDistanceFromLatLonInKm(results[0].latitude, results[0].longitude, results[1].latitude, results[1].longitude); //latitude , longitude 
      if (distance > 0 && distance < 20) {
        timeReturn = 30;
      } else if (distance >= 20 && distance <= 50) {
        timeReturn = 60
      } else if (distance > 40 && distance < 80) {
        timeReturn = 90
      } else {
        timeReturn = 120
      }
    }
    accumilatedTime = moment(bookings[0].end_time).add(timeReturn, 'minutes').tz("Asia/Colombo").format('HH:mm');
    if (moment(dateMonthAsWord + " " + accumilatedTime) > moment(dateMonthAsWord + " 16:30")) {
      return "16:30";
    }
    return accumilatedTime;
  } else {
    return moment("07:59").add(timeReturn, 'minutes').tz("Asia/Colombo").format('HH:mm');
  }
}

app.get('/locations', (req, res) => {
  const { table } = req.query;
  pool.query
  pool.query(`select * from locations`, (err, results) => {
    if (err) {
      return res.send(err);
    } else {
      return res.send(results);
    }
  });
});