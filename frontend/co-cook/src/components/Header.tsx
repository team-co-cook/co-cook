import styled from "styled-components";

function Header() {
  return (
    <StyledHeader>
      <h1>코쿡으로 쉽고 편한 요리</h1>
    </StyledHeader>
  );
}

export default Header;

const StyledHeader = styled.header`
  width: 100%;
  max-width: 980px;
  height: 100px;
  ${({ theme }) => theme.fontStyles.subtitle1}
  font-size: 3rem;
  text-align: center;
`;
