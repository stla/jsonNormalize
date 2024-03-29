// https://gist.github.com/dfkaye/dcb060a13470de8119833dc56933563f

/**
 * Helper functions and queries for normalize() method.
 */

const BLANK_LINES = /([\n](\s)*(?:\n))/g;
const LINE_COMMENTS = /[\"\']*(?:[\s\w]]*)(\/\/[^\n^\"^\}]*)/g;
// Attempt to handle /* */ and /** javadoc style * line * line2 comments */
const MULTILINE_COMMENTS = /[\"\']*(?:\s*)(\/\*+)([^\*]*[\*])([^\/]*[\/])/g;
const SINGLE_QUOTES = /([^\\][\'](?:[^\']*)[\'](?:[^\}^\:^\,]*))/g;
// 23 May 2023 - Stéphane Laurent
// added \[ to handle first element of array
const UNQUOTED_WORDS = /(?:(\,|\:|\{|\[)\s*)([\w]+)/g;

function addQuotes(e) {

  // return booleans and null unchanged
  if (/false|true|null/.test(e)) {
    return e;
  }

  // 23 May 2023 - Stéphane Laurent
  // handle numbers in scientific notation
  // https://stackoverflow.com/a/51790561/1100107
  if (/^[+\-]?(?=\.\d|\d)(?:0|[1-9]\d*)?(?:\.\d*)?(?:\d[eE][+\-]?\d+)?$/.test(e)) {
    return e;
  }

  // return numbers unchanged
  if (/^\d?\.?\d+$/.test(e)) {
    return e;
  }

  // replaces undefined, and NaN with empty string
  if (/undefined|NaN/.test(e)) {
    e = '';
  }

  return '"' + e + '"';
}

function replaceUnquoted(m) {
  return m.replace(/\w+/g, addQuotes);
}

/**
 * @method normalize Attempts to fix a JSON string with bare keys (restore
 * missing quotes) and single-quoted keys and values, and remove line comments,
 * block comments, blank lines, etc.
 * @param {string} jsonText
 * @returns {string}
 */

function normalize(jsonText) {
  var fixed = jsonText

    // 18 Oct 2018 - remove comments and blank lines
    // 30 Oct 2018 - preserve quoted comments
    // remove line comments
    .replace(LINE_COMMENTS, e => {

      // Ignore if line comment is quoted.
      return /[\"\']([\s\w]*[\:])?/.test(e[0]) ? e : '';
    })

    // remove multi-line comments
    .replace(MULTILINE_COMMENTS, e => {

      // Ignore if comment is quoted.
      return /[\"\']/.test(e[0]) ? e : '';
    })

    // remove blank lines
    .replace(BLANK_LINES, '\n')

    // 17,18 oct 2018
    // fix single quotes
    // 15 feb 2019
    // escaped apostrophes
    .replace(SINGLE_QUOTES, (m) => {

      /*
       * Replace leading and trailing single quotes with double quotes, trim
       * quoted spaces, ignore quoted apostrophes.
       */

      var t = m.trim();
      var p = m.split(t);
      var r = p[0] + t.replace(/^[\']/, '"') + p[1];

      return r.replace(/([\'])(?:[\s]*)$/, (e) => {
        return '"' + (e.length > 1 ? e.substring(1) : '');
      });
    })

    // 17 october 2018
    // success
    // add missing quotes
    .replace(UNQUOTED_WORDS, replaceUnquoted)

    // 28 December 2019 - fix [01] and { 01: 01 }
    // e.g., replace 01 with "01"
    //
    // 23 May 2023 - Stéphane Laurent
    // also replace numeric key by string
    .replace(/(?=[^\'|\"]+)[0-9]+([0-9)+(?=[^\"^\']+)+(?=:)/g, function (e) {
      //return '"' + e + '"';
      return /(\d+(?=:))/.test(e) ? '"' + e + '"' : e;
    })

    // 23 May 2023 - Stéphane Laurent
    // get rid of successive quotes
    .replace(/([\"\']{2,})[0-9]+([\"\']{2,})+/g, function (e) {
      var ee = e.replace(/\"/g, "").replace(/'/g, "");
      return '"' + ee + '"';
      //return /\d+(?=,)/.test(ee) ? ee : '"' + ee + '"';
    })

    // trim it
    .trim();

  return fixed;
}
