import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import Mockup from "../common/Mockup";
import splashImg from "@/image/splashImg.png";
import recipeScreen from "@/image/recipeScreen.png";
import themeScreen from "@/image/themeScreen.png";
import voiceScreen from "@/videos/voiceScreen.mp4";
import homeScreen from "@/videos/homeScreen.mp4";
import { useEffect, useState } from "react";
function HeaderMockup() {
  const [scrollLocation, setScrollLocation] = useState(0);
  const windowScrollListener = (e) => {
    setScrollLocation(document.documentElement.scrollTop);
  };
  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);
  return _jsx("div", {
    children: _jsxs(StyledHeaderMockup, {
      children: [
        _jsx("div", {
          className: "move-mockup",
          style: { paddingTop: (64 / 400) * (400 - scrollLocation) },
          children: _jsx(Mockup, { isVideo: false, screen: themeScreen, isRotate: false }),
        }),
        _jsx("div", {
          children: _jsx(Mockup, { isVideo: true, screen: homeScreen, isRotate: false }),
        }),
        _jsx("div", {
          className: "move-mockup",
          style: { paddingTop: (64 / 400) * (400 - scrollLocation) },
          children: _jsx(Mockup, { isVideo: false, screen: splashImg, isRotate: false }),
        }),
        _jsx("div", {
          children: _jsx(Mockup, { isVideo: true, screen: voiceScreen, isRotate: false }),
        }),
        _jsx("div", {
          className: "move-mockup",
          style: { paddingTop: (64 / 400) * (400 - scrollLocation) },
          children: _jsx(Mockup, { isVideo: false, screen: recipeScreen, isRotate: false }),
        }),
      ],
    }),
  });
}
export default HeaderMockup;
const StyledHeaderMockup = styled.div`
  @keyframes fadeUp1 {
    0% {
      opacity: 0;
      transform: translateY(50px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }
  @keyframes fadeUp2 {
    0% {
      opacity: 0;
      transform: translateY(100px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }

  z-index: -1;
  display: flex;
  align-items: c;
  position: absolute;
  left: 50%;
  transform: translate(-50%, 0%);
  overflow: hidden;

  & > div {
    height: 350px;
    margin: 8px;
    animation: fadeUp1 1s ease-out;
    @media (min-width: 734px) {
      height: 520px;
    }
    @media (min-width: 1068px) {
      height: 700px;
    }
  }
  .move-mockup {
    transition: all ease-out 0.2s;
    animation: fadeUp2 1s ease-out;
  }
`;
