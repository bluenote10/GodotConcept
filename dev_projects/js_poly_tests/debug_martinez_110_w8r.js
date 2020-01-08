#!/usr/bin/env node
// Test martinez bug https://github.com/w8r/martinez/issues/110 with Polybooljs

// We need to run this with:
// node -r esm ./debug_martinez_110_check.js
// To make node work with ES6 modules...
// https://stackoverflow.com/questions/45854169/how-can-i-use-an-es6-import-in-node

const converter = require("./converter_w8r");
const exec = require('child_process').exec;

var bug_id = 110;

//const martinez = require("../../geo-clip/references/martinez/src/index");
//import * as martinez from "../../geo-clip/references/martinez/src/index";
import * as martinez from "../../geo-clip/references/martinez/index";
debugger;


//const p1 = [[[0, 0], [100, 200], [200, 300], [0, 0]]];
//const p2 = [[[20, 20], [60, 300], [100, 120], [20, 20]]];

// Funny variations:
// - changing first x 115 => 116
// - changing first x 115 => 114
// - changing first y 96 => 97
// Fixes:
// - changing third x 120 => 121 (the point that cuts the short segment)
const p1 = [[[115,96], [140,206], [120,210], [125,250], [80,300], [115,96]]];
const p2 = [[[111,228], [129,192], [309,282], [111,228]]];
const union = martinez.union(p1, p2);

console.log("raw output:", JSON.stringify(union));

const fn_i = `bug_${bug_id}_w8r_input.json`;
const fn_o = `bug_${bug_id}_w8r_output.json`;
converter.store_polygons([p1, p2], fn_i);
converter.store_polygons(union, fn_o);

// [[[[0,0],[24,48],[87.6923076923077,175.3846153846154],[100,120],[20,20]]],[[[100,200],[200,300]]]]
// [[[[0,0],[24,48],[87.6923076923077,175.3846153846154],[100,120],[20,20]]],[[[100,200],[200,300]]]]

exec(`../../scripts/plot_world.py ${fn_i} ${fn_o}`, function callback(error, stdout, stderr){
  // result
});

/*
var PolyBool = require('polybooljs');

let polygon1 = {
  "regions":[
    [[115,96], [140,206], [120,210], [125,250], [80,300]]
  ],"inverted":false
}
let polygon2 = {
  "regions":[
    [[111,228], [129,192], [309,282]]
  ],"inverted":false
}

converter.store_polygons([polygon1, polygon2], `bug_${bug_id}_input.json`);

var union = PolyBool.union(polygon1, polygon2);
console.log(JSON.stringify(union));

converter.store_polygons([union], `bug_${bug_id}_output.json`);
*/