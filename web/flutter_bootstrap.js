{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    useLocalCanvasKit: true,
    renderer: "canvaskit",
  },
}).catch((error) => {
  const details = error && error.stack ? `${error}\n${error.stack}` : String(error);
  if (typeof window.showBootError === 'function') {
    window.showBootError(`Loader failed: ${details}`);
  } else {
    console.error('Loader failed:', error);
  }
});
