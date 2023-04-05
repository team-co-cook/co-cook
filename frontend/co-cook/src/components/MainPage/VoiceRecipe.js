import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import timer from "@/videos/timer.mp4";
import recipeNext from "@/videos/recipeNext.mp4";
import audioWave from "@/videos/audioWave.mp4";
import { useEffect, useState } from "react";
function VoiceRecipe() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });
  const [scrollLocation, setScrollLocation] = useState(0);
  const windowScrollListener = (e) => {
    setScrollLocation(document.documentElement.scrollTop);
    setWordIdx(Math.ceil(document.documentElement.scrollTop / 100) % 4);
  };
  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);
  const wordComponent = [
    _jsx("h2", { children: '"\uCF54\uCFE1, \uD0C0\uC774\uBA38"' }),
    _jsx("h2", { children: '"\uCF54\uCFE1, \uB2E4\uC74C"' }),
    _jsx("h2", { children: '"\uCF54\uCFE1, \uB2E4\uC2DC"' }),
    _jsx("h2", { children: '"\uCF54\uCFE1, \uC774\uC804"' }),
  ];
  const [wordIdx, setWordIdx] = useState(0);
  return _jsxs(StyledVoiceRecipe, {
    ref: ref,
    inView: inView,
    children: [
      _jsxs("div", {
        className: "mockup",
        children: [
          _jsx("div", {
            style: { paddingLeft: scrollLocation / 7 },
            children: _jsx(Mockup, { isVideo: true, screen: timer, isRotate: true }),
          }),
          _jsx("div", {
            style: { paddingLeft: scrollLocation / 30 },
            children: _jsx(Mockup, { isVideo: true, screen: recipeNext, isRotate: true }),
          }),
        ],
      }),
      _jsxs("div", {
        children: [
          _jsx("video", { src: audioWave, autoPlay: true, loop: true, muted: true }),
          wordComponent[wordIdx],
          _jsx("p", {
            children:
              "\uC694\uB9AC \uC911 \uC190\uC744 \uC4F0\uAE30 \uD798\uB4E4\uB2E4\uBA74 \uC5B8\uC81C\uB4E0 \uB9D0\uB9CC \uD558\uC138\uC694.",
          }),
        ],
      }),
    ],
  });
}
export default VoiceRecipe;
const StyledVoiceRecipe = styled.section`
  display: flex;
  align-items: center;
  height: 650px;
  width: 100%;
  text-align: right;

  @media (max-width: 734px) {
    flex-direction: column-reverse;
    justify-content: center;
  }

  & > div {
    width: 40%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    @media (max-width: 734px) {
      width: 100%;
    }
    flex-shrink: 0;

    & > video {
      width: 200px;
      margin-bottom: 16px;
      mix-blend-mode: multiply;
      ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
    }

    & > h2 {
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle2}
      font-size: 2.5rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
    }
    & > p {
      margin-top: 16px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.body1}
      font-size: 1rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      animation: fadeUp1 0.5s ease-out;
      ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
    }
  }
  .mockup {
    width: 60%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: start;
    @media (max-width: 734px) {
      width: 100%;
      height: 50%;
      margin-left: 30px;
    }
    & > div {
      width: 60%;
      height: 30%;
      display: flex;

      align-items: center;
      @media (max-width: 734px) {
        justify-content: center;
        width: 100%;
        margin-left: -60px;
      }
      @media (min-width: 734px) {
        margin-left: 20px;
      }
      @media (min-width: 1068px) {
        margin-left: 100px;
      }
    }
  }
`;
