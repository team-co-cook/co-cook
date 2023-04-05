import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import cameraSearch from "@/videos/cameraSearch.mp4";
import { useEffect, useState } from "react";
import cocookLens from "@/image/cocookLens.png";
function PhotoSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });
  const [scrollLocation, setScrollLocation] = useState(0);
  const windowScrollListener = (e) => {
    setScrollLocation((document.documentElement.scrollTop / 7 - 260) * -1);
  };
  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);
  return _jsx(StyledPhotoSearch, {
    ref: ref,
    inView: inView,
    children: _jsxs("div", {
      children: [
        _jsx("div", {
          className: "mockup",
          style: {
            transform: `translateY(${scrollLocation}px)`,
          },
          children: _jsx(Mockup, { isVideo: true, screen: cameraSearch, isRotate: false }),
        }),
        _jsxs("div", {
          children: [
            _jsx("img", { src: cocookLens, alt: "" }),
            _jsx("h2", { children: "\uCC30\uCE75 \uCC0D\uC5B4 \uB808\uC2DC\uD53C \uD655\uC778" }),
            _jsx("p", {
              children:
                "\uB0B4 \uC55E\uC5D0 \uC788\uB294 \uC74C\uC2DD\uC758 \uB808\uC2DC\uD53C\uAC00 \uAD81\uAE08\uD558\uC2E0\uAC00\uC694?",
            }),
            _jsx("p", { children: "\uC0AC\uC9C4\uB9CC \uCC0D\uC5B4\uBCF4\uC138\uC694." }),
          ],
        }),
      ],
    }),
  });
}
export default PhotoSearch;
const StyledPhotoSearch = styled.section`
  @keyframes contentFade {
    0% {
      opacity: 0;
      transform: translateY(50px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }
  height: 600px;
  width: 100%;
  @media (max-width: 734px) {
    height: 700px;
  }
  & > div {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    width: 100%;
    @media (max-width: 734px) {
      flex-direction: column-reverse;
    }
    & > div {
      width: 50%;
      text-align: center;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      @media (max-width: 734px) {
        width: 90%;
        height: 40%;
        margin-top: 24px;
      }
      & > img {
        width: 100px;
      }
      & > h2 {
        margin-block: 16px;
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.subtitle2}
        font-size: 2.5rem;
        line-height: 1.2;
        ${({ inView }) =>
          inView
            ? "animation: contentFade 0.5s ease-out;"
            : "opacity: 0; transform: translateY(50px);"}
        color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      }
      & > p {
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.body1}
        font-size: 1rem;
        margin-bottom: 8px;
        color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
        ${({ inView }) =>
          inView
            ? "animation: contentFade 0.5s ease-out;"
            : "opacity: 0; transform: translateY(50px);"}
      }
    }
  }
  .mockup {
    display: flex;
    justify-content: center;
    @media (max-width: 734px) {
      width: 90%;
      height: 60%;
    }
  }
`;
