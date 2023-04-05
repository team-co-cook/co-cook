import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import mockupImg from "@/image/mockupImg.png";
function Mockup(props) {
  return _jsxs(StyledMockup, {
    isRotate: props.isRotate,
    children: [
      _jsx("img", { className: "mockup-img", src: mockupImg, alt: "" }),
      _jsx("div", {
        className: "mockup-screen",
        children: props.isVideo
          ? _jsx("video", {
              className: "mockup-screen-img",
              autoPlay: true,
              loop: true,
              muted: true,
              children: _jsx("source", { src: props.screen, type: "video/mp4" }),
            })
          : _jsx("img", { className: "mockup-screen-img", src: props.screen, alt: "screen" }),
      }),
    ],
  });
}
export default Mockup;
const StyledMockup = styled.div`
  z-index: -2;
  ${({ isRotate }) => (isRotate ? "transform: rotate(90deg);" : null)}

  width: 150px;
  @media (min-width: 734px) {
    width: 220px;
  }
  @media (min-width: 1068px) {
    width: 300px;
  }
  position: relative;
  aspect-ratio: 1/2.19;
  .mockup-img {
    mix-blend-mode: darken;
    position: absolute;
    top: 0px;
    left: 0px;
    margin-top: 8%;
    margin-left: 1%;
    width: 100%;
  }
  .mockup-screen {
    z-index: -1;
    position: absolute;
    border-radius: 6%;
    top: 0px;
    left: 0px;
    width: 100%;
    scale: 0.9;

    &-img {
      width: 100%;
      aspect-ratio: 1/2.19;
      border-radius: 6%;
    }
  }
`;
