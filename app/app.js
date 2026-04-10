const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("🚀 Production EKS DevOps Project Running");
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "UP" });
});

app.listen(3000, () => console.log("Server started"));
