import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import { Link } from "react-router-dom";
import styled from "styled-components";
import cocookAi from "@/image/cocookAi.png";
import { useInView } from "react-intersection-observer";
import { ReactComponent as LogoWhite } from "@/logo/logoWhite.svg";
function Footer() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });
  return _jsxs(StyledFooter, {
    ref: ref,
    inView: inView,
    children: [
      _jsx("div", { className: "ai", children: _jsx("img", { src: cocookAi, alt: "" }) }),
      _jsx("h2", { children: "\uCF54\uCFE1\uB9CC\uC758 \uC74C\uC131AI \uAE30\uC220" }),
      _jsx("p", {
        children: "AI\uB85C \uC190\uC26C\uC6B4 \uC694\uB9AC\uB97C \uACBD\uD5D8\uD558\uC138\uC694.",
      }),
      _jsxs("div", {
        className: "download",
        children: [
          _jsx(LogoWhite, { className: "nav-logo" }),
          _jsx(Link, {
            to: "/install",
            className: "nav-link",
            children: "\uC9C0\uAE08 \uB2E4\uC6B4\uB85C\uB4DC \uBC1B\uAE30",
          }),
        ],
      }),
      _jsx("div", { className: "spacer" }),
    ],
  });
}
export default Footer;
const StyledFooter = styled.header`
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
  text-align: center;
  & > h2 {
    margin-block: 16px;
    word-break: keep-all;
    margin-top: 80px;
    ${({ theme }) => theme.fontStyles.subtitle2}
    font-size: 2.5rem;
    line-height: 1.2;
    ${({ inView }) =>
      inView ? "animation: contentFade 0.5s ease-out;" : "opacity: 0; transform: translateY(50px);"}
    color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
  }
  & > p {
    word-break: keep-all;
    ${({ theme }) => theme.fontStyles.body1}
    font-size: 1rem;
    margin-bottom: 8px;
    color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    ${({ inView }) =>
      inView ? "animation: contentFade 0.5s ease-out;" : "opacity: 0; transform: translateY(50px);"}
  }
  .ai {
    height: 300px;
    width: 100%;
    @media (max-width: 734px) {
      height: 50vw;
    }
    display: flex;
    justify-content: center;
    align-items: center;
    & > img {
      width: 600px;
      @media (max-width: 734px) {
        width: 90%;
      }
    }
  }
  .download {
    width: 100vw;
    background-color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    margin-top: 100px;
    padding-top: 24px;
    padding-bottom: 80px;
    height: 200px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .nav-link {
    padding: 12px 18px;
    border: 1px solid ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    margin-bottom: 24px;
    border-radius: 16px;
    color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    text-decoration: none;
    ${({ theme }) => theme.fontStyles.button}
    cursor: pointer;
    transition: all 0.1s;
    &:hover {
      background-color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    }
    &:active {
      scale: 0.95;
    }
  }
`;
