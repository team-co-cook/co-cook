import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import timer from "../../assets/videos/timer.mp4";
import recipeNext from "../../assets/videos/recipeNext.mp4";
import audioWave from "../../assets/videos/audioWave.mp4";

function VoiceRecipe() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  return (
    <StyledVoiceRecipe ref={ref} inView={inView}>
      <div>
        <h2>"코쿡, 타이머"</h2>
        <p>요리 중 손을 쓰기 힘들다면 언제든 말만 하세요.</p>
      </div>
    </StyledVoiceRecipe>
  );
}

export default VoiceRecipe;

const StyledVoiceRecipe = styled.section<{ inView: boolean }>``;
