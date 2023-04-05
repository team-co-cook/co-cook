import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import { Link } from "react-router-dom";
import styled from "styled-components";
import HeaderMockup from "./HeaderMockup";
function Header() {
    return (_jsxs(StyledHeader, { children: [_jsxs("div", { children: [_jsx("h1", { children: "\uCF54\uCFE1\uACFC \uD568\uAED8" }), _jsx("h1", { children: "\uC190\uC26C\uC6B4 \uC694\uB9AC\uC0DD\uD65C" })] }), _jsx(Link, { to: "/install", className: "nav-link", children: "\uC9C0\uAE08 \uB2E4\uC6B4\uB85C\uB4DC \uBC1B\uAE30" }), _jsx("section", { children: _jsx(HeaderMockup, {}) })] }));
}
export default Header;
const StyledHeader = styled.header `
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

  justify-content: center;
  display: flex;
  align-items: center;
  justify-content: start;
  flex-direction: column;
  width: 100%;
  max-width: 980px;
  overflow-y: hidden;

  & > div {
    margin-top: 64px;
    margin-bottom: 32px;

    & > h1 {
      margin-top: 16px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle1}
      font-size: 3.5rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      animation: fadeUp1 0.5s ease-out;
    }
  }
  .nav-link {
    padding: 12px 18px;
    border: 1px solid ${({ theme }) => theme.Colors.RED_PRIMARY};
    margin-bottom: 24px;
    border-radius: 16px;
    color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    text-decoration: none;
    ${({ theme }) => theme.fontStyles.button}
    cursor: pointer;
    transition: all 0.1s;
    &:hover {
      background-color: ${({ theme }) => theme.Colors.RED_PRIMARY};
      color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    }
    &:active {
      scale: 0.95;
    }
  }
  & > section {
    width: 100%;
    height: 400px;
    @media (min-width: 734px) {
      height: 520px;
    }
    @media (min-width: 1068px) {
      height: 700px;
    }
  }
`;
