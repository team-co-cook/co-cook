import styled from "styled-components";
import Header from "../components/Header";
import NavBar from "../components/NavBar";

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
