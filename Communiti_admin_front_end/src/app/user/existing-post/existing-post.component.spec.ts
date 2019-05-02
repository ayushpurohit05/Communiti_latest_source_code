import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ExistingPostComponent } from './existing-post.component';

describe('ExistingPostComponent', () => {
  let component: ExistingPostComponent;
  let fixture: ComponentFixture<ExistingPostComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ExistingPostComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExistingPostComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
