import { NavLink } from "react-router-dom";
import styled from "styled-components";
import { ReactComponent as LogoRed } from "@/logo/logoRed.svg";

function NavBar() {
  return (
    <StyledNavBar>
      <NavLink to={"/"}>
        <LogoRed className="nav-logo" />
      </NavLink>
      <NavLink to={"/install"} className="nav-link">
        Download
      </NavLink>
    </StyledNavBar>
  );
}

export default NavBar;

const StyledNavBar = styled.nav`
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  max-width: 980px;
  height: 100px;

  .nav-logo {
    height: 96px;
    cursor: pointer;
    transition: all 0.3s;
    &:hover {
      scale: 1.1;
      filter: drop-shadow(-2px 4px 0px ${({ theme }) => theme.Colors.RED_TERTIARY});
    }
    &:active {
      transition: all 0.1s;
      filter: drop-shadow(0px 0px 0px ${({ theme }) => theme.Colors.RED_TERTIARY});
    }
  }

  .nav-link {
    padding: 12px 18px;
    border: 1px solid ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    border-radius: 16px;
    color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    text-decoration: none;
    ${({ theme }) => theme.fontStyles.button}
    cursor: pointer;
    transition: all ease-out 0.1s;
    &:hover {
      background-color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    }
    &:active {
      scale: 0.95;
    }
  }
`;
