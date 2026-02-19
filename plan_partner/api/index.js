const express = require('express');
const cors = require('cors');
const app = express();
const tasksRouter = require('./routes/tasks');

app.use(cors());
app.use(express.json());
app.use('/tasks', tasksRouter);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API listening on port ${PORT}`));
