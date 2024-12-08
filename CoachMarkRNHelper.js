import { NativeModules } from 'react-native';

const { CoachMarkModule } = NativeModules;

const CoachMarkRNHelper = {
  showCoachMarks: (jsonString, onComplete) => {
    CoachMarkModule.showCoachMarks(jsonString, onComplete);
  },
};

export default CoachMarkRNHelper;
