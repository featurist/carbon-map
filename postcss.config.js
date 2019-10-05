module.exports = {
  plugins: [
    require("postcss-import"),
    require("postcss-simple-vars"),
    require("postcss-custom-media"),
    require("postcss-flexbugs-fixes"),
    require("postcss-preset-env")({
      autoprefixer: {
        flexbox: "no-2009"
      },
      stage: 3
    })
  ]
};
