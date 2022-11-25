const express = require("express");
const app = express();
const cors = require("cors");
const dotevt = require("dotenv");
const fileUpload = require("express-fileupload");
const handlebars = require("express-handlebars");
dotevt.config();

const server = require("http").createServer(app);

const corsOptions = {
  origin: "*",
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));

const bodyParser = require("body-parser");
app.use(bodyParser.json({ limit: "1024mb" }));
app.use(bodyParser.urlencoded({ limit: "1024mb", extended: true }));

app.use(fileUpload({}));

const io = require("socket.io")(server, {
  cors: {
    origin: "*",
  },
});

const conversationController = require("./src/conversation/controller");
const messagesController = require("./src/messages/controller");
const { existsConversation } = require("./src/conversation/controller");
const { markAsRead, markAsReadMine } = require("./src/messages/controller");

io.on("connection", (socket) => {
  socket.on("join-room", (room) => {
    socket.join(room);
  });
  socket.on("open-chat", function (data) {
    io.to(data.to).emit("open-chat", {
      from: data.from,
    });
  });

  socket.on("start-video", function (data) {
    console.log("start-video", data);
    io.to(data.to).emit("start-video", {
      from: data.from,
      roomId: data.roomId,
      name: data.name,
    });
  });

  socket.on("stop-video", function (data) {
    io.to(data.to).emit("stop-video", {
      from: data.from,
      roomId: data.roomId,
    });
  });

  socket.on("send-message", function (data) {
    conversationController
      .getConversation({
        from: data.from,
        to: data.to,
      })
      .then((conversationID) => {
        data.conv_uuid = conversationID;
        messagesController.insertMessage(data).then(() => {
          const z = {};
          if (data.message) {
            z.message = data.message;
          }
          if (data.opts) {
            z.opts = data.opts;
            z.mess_date = data.mess_date;
          }
          z.from = data.from;
          z.mess_date = data.mess_date;
          io.to(data.to).emit("new-message", z);
        });
      });
  });
  socket.on("ask-me-to-reload-users", function () {
    socket.emit("user-reload");
  });
  socket.on("typing-to", function (data) {
    io.to(data.to).emit("typing", { from: data.from });
  });

  socket.on("message-read", function (data) {
    existsConversation(data).then((uuid) => {
      if (uuid !== -1) {
        console.log("[Exists conversation] --->", uuid);
        markAsReadMine(uuid, data.from).then(() => {
          console.log("Marked as read!");
          io.to(data.from).emit("your-message-read", {
            from: data.from,
            to: data.to,
          });
        });
      }
    });
  });

  socket.on("call-accepted", ({ to, from, roomId }) => {
    console.log("[index.js] call-accepted");

    io.to(to).emit("stop-ringing", { roomId });
    io.to(from).emit("stop-ringing", { roomId });

    io.to(to).emit("call-accepted", {
      roomId: roomId,
    });
  });
});

app.locals.io = io;

app.set("view engine", "handlebars");
app.engine(
  "handlebars",
  handlebars({ layoutsDir: __dirname + "/views/layouts" })
);

app.use(express.json());
app.use("/public", express.static("public"));
app.use(express.static(__dirname + "/upload"));
app.use("/generated", express.static(__dirname + "/generated"));

app.use("/user-role", require("./src/user-role/routes"));
app.use("/user", require("./src/user/routes"));
app.use("/file", require("./src/file/routes"));
app.use("/conversation", require("./src/conversation/routes"));
app.use("/my-professional", require("./src/my-professionals/routes"));
app.use("/previous-chats", require("./src/previous-conversations/routes"));
app.use("/home-screen", require("./src/home-screen/routes"));
app.use("/medical-record", require("./src/medical-record/routes"));
app.use("/content", require("./src/content/routes"));
app.use("/page", require("./src/page/routes"));
app.use("/main-text", require("./src/main-text/routes"));
app.use("/category", require("./src/category/routes"));
app.use("/professional", require("./src/professional/routes"));
app.use("/verification-code", require("./src/verification-code/routes"));
app.use("/my-doctor", require("./src/my-doctor/routes"));
app.use("/address", require("./src/address/routes"));
app.use("/specialty", require("./src/specialty/routes"));
app.use("/hcfa", require("./src/hcfa/routes"));
app.use("/insured", require("./src/insured/routes"));
app.use("/claims", require("./src/claims/routes"));

const port = process.env.PORT || 5000;
server.listen(port, () => {
  console.log("Server running on port " + port);
});
