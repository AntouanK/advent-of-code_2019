var main = require("./main");

process.stdin.setEncoding("utf8");

var input = "";

process.stdin.on("readable", () => {
  // Use a loop to make sure we read all available data.
  while ((chunk = process.stdin.read()) !== null) {
    input += chunk;
  }
});

process.stdin.on("end", () => {
  var flags = { input };

  var app = main.Elm.Main.init({ flags });

  app.ports.print.subscribe(function(data) {
    console.log(data);
  });
});
