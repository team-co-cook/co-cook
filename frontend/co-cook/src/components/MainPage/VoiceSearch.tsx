import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import voiceSearch from "../../assets/videos/voiceSearch.mp4";

function VoiceSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  return (
    <StyledVoiceSearch id="voice-search-section" ref={ref} inView={inView}>
      <div>
        <div className="title">
          <h2>"양파, 당근, 브로콜리..."</h2>
          <p>냉장고 속이 두려울 때,</p>
          <p>재료를 말하면 레시피를 추천해드립니다.</p>
        </div>
        <div className="mockup">
          <Mockup isVideo={true} screen={voiceSearch}></Mockup>
        </div>
      </div>
    </StyledVoiceSearch>
  );
}

export default VoiceSearch;

const StyledVoiceSearch = styled.section<{
  inView: boolean;
}>``;
