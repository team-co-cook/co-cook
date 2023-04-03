const windowSizes = {
  small: 'screen and (max-width: "600px")',
  base: 'screen and (max-width: "768px")',
  large: 'screen and (max-width: "1024px")',
};

const fontStyles = {
  title1:
    "font-size: 24px; font-family: Pretendard; font-weight: 900; letter-spacing: 0em;",

  title2:
    "font-size: 20px;font-family: Pretendard; font-weight: 900; letter-spacing: 0em;",

  subtitle1:
    "font-size: 16px; font-family: Pretendard; font-weight: 700; letter-spacing: 0em;",

  subtitle2:
    "font-size: 14px; font-family: Pretendard; font-weight: 700; letter-spacing: 0em;",

  body1:
    "font-size: 16px; font-family: Pretendard; font-weight: 400; letter-spacing: 0em;",

  body2:
    "font-size: 14px; font-family: Pretendard; font-weight: 400; letter-spacing: 0em;",

  button:
    "font-size: 14px; font-family: Pretendard; font-weight: 700; letter-spacing: 0em; text-transform: uppercase;",

  caption:
    "font-size: 12px; font-family: Pretendard; font-weight: 400; letter-spacing: 0em;",

  overline:
    "font-size: 10px; font-family: Pretendard; font-weight: 400; letter-spacing: 0em; text-transform: uppercase;",
  logo: "font-size: 24px; font-family: League Gothic; font-weight: 400; letter-spacing: 0em;",
};

const Colors = {
  RED_LIGHT: "rgb(244, 244, 244)",
  RED_TERTIARY: "rgb(243, 181, 168)",
  RED_SECONDARY: "rgb(217, 91, 79)",
  RED_PRIMARY: "rgb(217, 22, 4)",
  MONOTONE_BLACK: "rgb(46, 41, 40)",
  MONOTONE_GRAY: "rgb(120, 112, 111)",
  MONOTONE_LIGHT_GRAY: "rgb(223, 221, 221)",
  MONOTONE_LIGHT: "rgb(252, 252, 252)",
  GREEN_PRIMARY: "rgb(60, 168, 51)",
  BROWN_PRIMARY: "rgb(134, 104, 68)",
};

const theme = {
  windowSizes,
  fontStyles,
  Colors,
};

export default theme;
