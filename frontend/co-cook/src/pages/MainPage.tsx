import styled from "styled-components";
import NavBar from "../components/common/NavBar";
import Header from "../components/MainPage/Header";

function MainPage() {
  return (
    <StyledMainPage>
      <NavBar />
      <Header />
    </StyledMainPage>
  );
}

export default MainPage;

const StyledMainPage = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-inline: 24px;
`;
