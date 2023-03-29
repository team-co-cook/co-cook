import styled from "styled-components";
import NavBar from "../components/common/NavBar";
import Header from "../components/MainPage/Header";
import PhotoSearch from "../components/MainPage/PhotoSearch";
import VoiceRecipe from "../components/MainPage/VoiceRecipe";
import VoiceSearch from "../components/MainPage/VoiceSearch";

function MainPage() {
  return (
    <StyledMainPage>
      <NavBar />
      <Header />
      <VoiceRecipe />
      <VoiceSearch />
      <PhotoSearch />
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
