const samplePromise = new Promise((resolve) => resolve(1));
const samplePromise2 = new Promise((resolve) => resolve(2));
const samplePromise3 = new Promise((resolve) => resolve(2));

const [hahahahhahahaahahaha, aljdflakjldfjalkd, ahahahahahah] = [
  1,
  2,
  "hdhdhdhdahdfasdfasfd",
];

const [promise1, promise2, promise3] = await Promise.all([
  samplePromise,
  samplePromise2,
  samplePromise3,
]);

const basic = "hey";

function hey() {
  const b = "hey";
  const { x, y, z } = { x: 1, y: 2, z: 3 };
  try {
    const hey = "x";
    console.log("hey:", hey);
    console.log("hey:", hey);
    const { x, y, z } = { x: 1, y: 2, z: 3 };
    const [a, b] = [1, 2];
  } catch (e) {
    print("stuff");
  }
}

const { x, y, z } = { x: 1, y: 2, z: 3 };

const {
  x: test,
  y: anotherTest,
  z: anotherValue,
} = {
  x: 10,
  y: 20,
  z: 30,
};

async function test() {
  const test = "ext";

  const [promise1, promise2, promise3] = await promise.all([
    samplepromise,
    samplepromise2,
    samplepromise3,
  ]);

  const {
    x: selection,
    y: anothertest,
    z: anothervalue,
  } = {
    x: 10,
    y: 20,
    z: 30,
  };
}

const { a, b, c } = { a: 1, b: 2, c: 3 };
console.log("test:", test);

async function test3() {
  try {
    const [promise1, promise2, promise3] = await promise.all([
      samplepromise,
      samplepromise2,
      samplepromise3,
    ]);
    const x = [1, 2, 3];
    for (const num of x) {
      const newNum = num + 5;
    }
    const rand = "str";
    const { a, b } = { a: 1, b: 2 };
    const {
      x: test2,
      y: anotherTest,
      z: anotherValue,
    } = {
      x: 10,
      y: 20,
      z: 30,
    };
  } catch {}
  console.log(
    "test2:",
    test2,
    "anotherTest:",
    anotherTest,
    "anotherValue:",
    anotherValue,
  );
}
