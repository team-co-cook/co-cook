import styled from "styled-components";
import NavBar from "../components/common/NavBar";
import Header from "../components/MainPage/Header";
import PhotoSearch from "../components/MainPage/PhotoSearch";
import VoiceRecipe from "../components/MainPage/VoiceRecipe";
import VoiceSearch from "../components/MainPage/VoiceSearch";
import Footer from "../components/MainPage/Footer";

function MainPage() {
  return (
    <StyledMainPage>
      <NavBar />
      <Header />
      <VoiceRecipe />
      <VoiceSearch />
      <PhotoSearch />
      <Footer />
    </StyledMainPage>
  );
}

export default MainPage;

const StyledMainPage = styled.div`
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-inline: 24px;
  overflow-x: hidden;
  width: 100vw;
  box-sizing: border-box;
`;
