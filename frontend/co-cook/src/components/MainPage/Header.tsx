import styled from "styled-components";
import HeaderMockup from "./HeaderMockup";

function Header() {
  return (
    <StyledHeader>
      <h1>코쿡과 함께하는 쉽고 편한 요리</h1>
      <HeaderMockup />
    </StyledHeader>
  );
}

export default Header;

const StyledHeader = styled.header`
  width: 100%;
  max-width: 980px;
  overflow-y: hidden;

  & > h1 {
    word-break: keep-all;
    ${({ theme }) => theme.fontStyles.subtitle1}
    font-size: 3rem;
    text-align: center;
  }
`;
