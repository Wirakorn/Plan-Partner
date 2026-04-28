const express = require('express');
const router = express.Router();

let tasks = [];
let nextId = 1;

router.get('/', (req, res) => {
  res.json(tasks);
});

router.get('/:id', (req, res) => {
  const id = Number(req.params.id);
  const t = tasks.find(x => x.id === id);
  if (!t) return res.status(404).json({ error: 'Not found' });
  res.json(t);
});

router.post('/', (req, res) => {
  const { title, description, done = false } = req.body;
  if (!title) return res.status(400).json({ error: 'title required' });
  const task = { id: nextId++, title, description, done };
  tasks.push(task);
  res.status(201).json(task);
});

router.put('/:id', (req, res) => {
  const id = Number(req.params.id);
  const idx = tasks.findIndex(x => x.id === id);
  if (idx < 0) return res.status(404).json({ error: 'Not found' });
  const { title, description, done } = req.body;
  tasks[idx] = {
    ...tasks[idx],
    title: title ?? tasks[idx].title,
    description: description ?? tasks[idx].description,
    done: done ?? tasks[idx].done
  };
  res.json(tasks[idx]);
});

router.delete('/:id', (req, res) => {
  const id = Number(req.params.id);
  const idx = tasks.findIndex(x => x.id === id);
  if (idx < 0) return res.status(404).json({ error: 'Not found' });
  const removed = tasks.splice(idx, 1)[0];
  res.json(removed);
});

module.exports = router;
