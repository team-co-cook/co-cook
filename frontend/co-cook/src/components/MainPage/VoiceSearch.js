import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import voiceSearch from "@/videos/voiceSearch.mp4";
import { useEffect, useState } from "react";
function VoiceSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });
  const [scrollLocation, setScrollLocation] = useState(0);
  const windowScrollListener = (e) => {
    setScrollLocation((document.documentElement.scrollTop / 6) * -1);
  };
  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);
  return _jsx(StyledVoiceSearch, {
    id: "voice-search-section",
    ref: ref,
    inView: inView,
    children: _jsxs("div", {
      children: [
        _jsxs("div", {
          className: "title",
          children: [
            _jsx("h2", { children: '"\uC591\uD30C, \uB2F9\uADFC, \uBE0C\uB85C\uCF5C\uB9AC..."' }),
            _jsx("p", { children: "\uB0C9\uC7A5\uACE0 \uC18D\uC774 \uB450\uB824\uC6B8 \uB54C," }),
            _jsx("p", {
              children:
                "\uC7AC\uB8CC\uB97C \uB9D0\uD558\uBA74 \uB808\uC2DC\uD53C\uB97C \uCD94\uCC9C\uD574\uB4DC\uB9BD\uB2C8\uB2E4.",
            }),
          ],
        }),
        _jsx("div", {
          style: {
            transform: `translateY(${scrollLocation}px)`,
          },
          className: "mockup",
          children: _jsx(Mockup, { isVideo: true, screen: voiceSearch, isRotate: false }),
        }),
      ],
    }),
  });
}
export default VoiceSearch;
const StyledVoiceSearch = styled.section`
  height: 500px;
  display: flex;
  align-items: center;
  width: 100%;
  text-align: left;
  & > div {
    display: flex;
    z-index: -3;
    width: 100%;
    height: 100%;
    background-size: cover;
    border-radius: 16px;
    @media (max-width: 734px) {
      flex-direction: column;
    }
    & > div {
      width: 65%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      @media (max-width: 734px) {
        width: 100%;
        height: 50%;
      }
      flex-shrink: 0;

      & > video {
        width: 100px;
        margin-bottom: 16px;
        mix-blend-mode: darken;
        ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
      }

      & > h2 {
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.subtitle2}
        font-size: 2.5rem;
        text-align: center;
        color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
        margin-bottom: 16px;
        line-height: 1.2;
        ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
      }
      & > p {
        margin-bottom: 8px;
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
      width: 30%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: start;
      margin-top: 200px;
      @media (max-width: 734px) {
        align-items: center;
        width: 100%;
        height: 50%;
      }
    }
  }
`;
