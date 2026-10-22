import test from "node:test";
import assert from "node:assert/strict";
import {
  buildCensusUrl,
  computeMetrics,
  escapeHtml,
  formatMetric,
  normalizeVariableCodes,
  parseCensusResponse,
  toCsv,
} from "../dist/lib.mjs";

test("buildCensusUrl creates a state query with all variables", () => {
  const url = new URL(buildCensusUrl({ year: 2024, geography: "state", state: "24", variables: ["NAME", "B01003_001E"] }));
  assert.equal(url.pathname, "/data/2024/acs/acs5");
  assert.equal(url.searchParams.get("get"), "NAME,B01003_001E");
  assert.equal(url.searchParams.get("for"), "state:24");
});

test("buildCensusUrl creates a county query scoped to a state", () => {
  const url = new URL(buildCensusUrl({ year: 2023, geography: "county", state: "06", county: "075", variables: ["NAME"] }));
  assert.equal(url.searchParams.get("for"), "county:075");
  assert.equal(url.searchParams.get("in"), "state:06");
});

test("buildCensusUrl creates a national ACS 5-year query", () => {
  const url = new URL(buildCensusUrl({ year: 2024, geography: "us", variables: ["NAME", "B01003_001E"] }));
  assert.equal(url.searchParams.get("for"), "us:1");
  assert.equal(url.pathname, "/data/2024/acs/acs5");
});

test("buildCensusUrl includes a user key only when supplied", () => {
  const keyed = new URL(buildCensusUrl({ year: 2024, geography: "state", state: "24", variables: ["NAME"], apiKey: "example-key" }));
  const anonymous = new URL(buildCensusUrl({ year: 2024, geography: "state", state: "24", variables: ["NAME"] }));
  assert.equal(keyed.searchParams.get("key"), "example-key");
  assert.equal(anonymous.searchParams.has("key"), false);
});

test("parseCensusResponse converts numeric fields while preserving identifiers", () => {
  const result = parseCensusResponse([
    ["NAME", "B01003_001E", "state", "county"],
    ["Example County", "12345", "01", "003"],
  ]);
  assert.deepEqual(result, [{ NAME: "Example County", B01003_001E: 12345, state: "01", county: "003" }]);
});

test("computeMetrics calculates rates and handles unavailable values", () => {
  const values = computeMetrics({
    B01003_001E: 1000,
    B19013_001E: 85000,
    B17001_002E: 120,
    B17001_001E: 960,
    B23025_002E: 700,
    B23025_005E: 35,
    B23025_003E: 665,
    B25003_001E: 400,
    B25003_002E: 260,
    B15003_001E: 700,
    B15003_022E: 100,
    B15003_023E: 70,
    B15003_024E: 30,
    B15003_025E: 20,
  });
  assert.equal(values.population.value, 1000);
  assert.equal(values.poverty.value, 12.5);
  assert.equal(values.unemployment.value, 5);
  assert.equal(values.homeownership.value, 65);
  assert.equal(values.bachelors.value, 31.4);
});

test("computeMetrics derives topic rates used by the atlas", () => {
  const values = computeMetrics({
    B03002_001E: 1000, B03002_003E: 400, B03002_012E: 200,
    B05002_001E: 1000, B05002_013E: 150,
    B16001_001E: 900, B16001_002E: 675,
    B11001_001E: 400, B11001_002E: 260,
    B08201_001E: 400, B08201_002E: 40,
    B08301_001E: 500, B08301_010E: 50, B08301_021E: 75,
    B27010_001E: 1000, B27010_017E: 20, B27010_033E: 30, B27010_050E: 40, B27010_066E: 10,
  });
  assert.equal(values.white.value, 40);
  assert.equal(values.hispanic.value, 20);
  assert.equal(values.foreignBorn.value, 15);
  assert.equal(values.nonEnglish.value, 25);
  assert.equal(values.familyHouseholds.value, 65);
  assert.equal(values.noVehicle.value, 10);
  assert.equal(values.transit.value, 10);
  assert.equal(values.workFromHome.value, 15);
  assert.equal(values.uninsured.value, 10);
});

test("formatMetric formats compact values, currency, and percentages", () => {
  assert.equal(formatMetric(1250000, "number"), "1.25M");
  assert.equal(formatMetric(85400, "currency"), "$85.4K");
  assert.equal(formatMetric(12.34, "percent"), "12.3%");
  assert.equal(formatMetric(2.618, "decimal"), "2.62");
  assert.equal(formatMetric(null, "number"), "Not available");
});

test("toCsv quotes commas and escapes quotes", () => {
  const csv = toCsv([{ place: "Austin, Texas", note: "A \"test\"", value: 3 }]);
  assert.equal(csv, 'place,note,value\r\n"Austin, Texas","A ""test""",3');
});

test("escapeHtml renders Census labels as text in HTML and quoted attributes", () => {
  assert.equal(escapeHtml('<img src=x onerror="alert(1)"> & O\'Brien'),
    '&lt;img src=x onerror=&quot;alert(1)&quot;&gt; &amp; O&#39;Brien');
});

test("toCsv prevents text values from becoming spreadsheet formulas", () => {
  assert.equal(toCsv([{ place: "=HYPERLINK(\"https://example.com\")", value: -3 }]),
    'place,value\r\n"\'=HYPERLINK(""https://example.com"")",-3');
});

test("normalizeVariableCodes accepts comma or whitespace separated Census variables", () => {
  assert.deepEqual(normalizeVariableCodes("b01003_001e, B19013_001E\nB01003_001E"), {
    valid: ["B01003_001E", "B19013_001E"], invalid: [], truncated: false,
  });
  assert.deepEqual(normalizeVariableCodes("B01003 bad-code").invalid, ["B01003", "BAD-CODE"]);
});
